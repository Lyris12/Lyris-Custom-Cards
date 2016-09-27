--Monument Bronzeboard
function c101010475.initial_effect(c)
    --Fusion Material: 2 Level 4, 5, or 6 LIGHT Machine-Type monsters
    aux.AddFusionProcFunRep(c,c101010475.ffilter,2,false)
    --Must first be Fusion Summoned with the above Fusion Materials.
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(aux.fuslimit)
    c:RegisterEffect(e0)
    --During either player's turn: You can target 2 face-up monsters your opponent controls, and apply the appropriate effects with both of those targets, depending on the original Levels of the monsters used as Fusion Material (in sequence); (effects below) You can only use this effect of "Monument Bronzeboard" once per turn.
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MATERIAL_CHECK)
    e1:SetValue(c101010475.matchk)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,101010475)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetLabel(0)
    e2:SetLabelObject(e1)
    e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION end)
    e2:SetTarget(c101010475.target)
    e2:SetOperation(c101010475.operation)
    c:RegisterEffect(e1)
end
function c101010475.ffilter(c)
    return c:IsLevelAbove(4) and c:IsLevelBelow(6) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c101010475.matchk(e,c)
    --local g=c:GetMaterial()
    --g:KeepAlive()
    e:SetLabelObject(g)-- c:GetMaterial())
end
function c101010475.mfilter(c,n)
    return c:GetLevel()==n
end
function c101010475.filter(c,g,f1,f2)
    if c:IsFacedown() then return false end
    if g:IsExists(c101010475.mfilter,2,nil,6) then return true end
    return f1(c) or f2(c)
end
function c101010475.filter1(c,f1,f2)
    return f1(c) and not f2(c)
end

function c101010475.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=e:GetLabelObject():GetLabelObject()
    local mg=g:Clone()
    local b1=mg:IsExists(c101010475.mfilter,1,nil,4) and not Card.IsDisabled
    local b2=mg:IsExists(c101010475.mfilter,1,nil,5) and Card.IsDestructable
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c101010475.filter,tp,0,LOCATION_MZONE,2,nil,mg,b1,b2) end
    local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local tg1=sg:FilterSelect(tp,c101010475.filter,tp,0,LOCATION_MZONE,1,1,nil,mg,b1,b2)
    local tc=tg:GetFirst()
    if not mg:IsExists(c101010475.mfilter,2,nil,6) then
        if b1(tc) and not b2(tc) then sg:Remove(c101010475.filter1,nil,b1,b2) end
        if b2(tc) and not b1(tc) then sg:Remove(c101010475.filter1,nil,b2,b1) end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local tg2=sg:Select(tp,1,1,nil):GetFirst()
    local mc=mg:GetFirst()
    local trg=Group.FromCards(tc,tg2)
    local trc=trg:GetFirst()
    local ct=0
    local dam1=nil
    local dam2=nil
    local og1=Group.CreateGroup()
    local og2=Group.CreateGroup()
    while trc do
        while mc do
            if mc:GetLevel()==4 then
                ct=CATEGORY_DISABLE
            elseif mc:GetLevel()==5 then
                ct=CATEGORY_DESTROY
            else
                ct=0
            end
            if ct==0 then
                if dam1==nil then
                    dam1=0
                    if mg:GetFirst():GetLevel()==6 then dam1=trc:GetAttack() end
                else
                    dam2=0
                    if mg:Filter(aux.TRUE,mg:GetFirst()):GetFirst():GetLevel()==6 then trc:GetAttack() end
                end
            elseif ct==CATEGORY_DISABLE then
                og1:AddCard(trc)
            else
                og2:AddCard(trc)
            end
            mc=mg:GetNext()
        end
        trc=trg:GetNext()
    end
    Duel.SetTargetCard(trg)
    if og1:GetCount()>0 then
        e:SetLabel(e:GetLabel()+0x1)
        e:SetCategory(e:GetCategory()+CATEGORY_DISABLE)
        Duel.SetOperationInfo(0,CATEGORY_DISABLE,og1,og1:GetCount(),0,0)
    end
    if og2:GetCount()>0 then
        e:SetLabel(e:GetLabel()+0x2)
        e:SetCategory(e:GetCategory()+CATEGORY_DESTROY)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,og2,og2:GetCount(),0,0)
    end
    if mg:IsExists(c101010475.mfilter,1,nil,6) then
        e:SetLabel(e:GetLabel()+0x4)
        e:SetCategory(e:GetCategory()+CATEGORY_DAMAGE)
        if mg:IsExists(c101010475.mfilter,2,nil,6) then Duel.SetTargetPlayer(1-tp) end
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam1+dam2)
    end
end
function c101010475.filter2(c,g)
    return g:IsContains(c)
end
function c101010475.filter3(c,e)
    return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c101010475.operation(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c101010475.filter3,nil,e)
    if tg:GetCount()~=2 then return end
    local mg=e:GetLabelObject():GetLabelObject()
    local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_DISABLE)
    local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
    local g1=tg:Filter(c101010475.filter2,nil,tg1)
    local g2=tg:Filter(c101010475.filter2,nil,tg2)
    local g3=tg:Clone()
    if bit.band(e:GetLabel(),0x1)==0x1 then
        --Level 4: Negate 1 of those targets' effects.
        local tc1=g1:GetFirst()
        while tc1 do

            tc1=g1:GetNext()
        end
        g3:Sub(g1)
    end
    if bit.band(e:GetLabel(),0x2)==0x2 then
        --Level 5: Destroy 1 of those targets.
        if bit.band(e:GetLabel(),0x1)==0x1 then Duel.BreakEffect() end
        Duel.Destroy(g2,REASON_EFFECT)
        g3:Sub(g2)
    end
    if bit.band(e:GetLabel(),0x4)==0x4 then
        --Level 6: Inflict damage to your opponent equal to 1 of those targets' ATK on the field.
        local dam=0
        if bit.band(e:GetLabel(),0x3)~=0 then Duel.BreakEffect() end
        if mg:IsExists(c101010475.mfilter,2,nil,6) then
            local tc2=tg:GetFirst()
            while tc2 do
                dam=dam+tc2:GetAttack()
                tc2=tg:GetNext()
            end
        else dam=g3:GetFirst():GetAttack()
        end
        Duel.Damage(1-tp,dam,REASON_EFFECT)
    end
end