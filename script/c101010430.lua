--機光襲雷竜－ビッグバン
function c101010430.initial_effect(c)
	--self-destruct
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_DESTROY)
	ae1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCode(EVENT_ATTACK_ANNOUNCE)
	ae1:SetCondition(c101010430.descon)
	ae1:SetOperation(c101010430.desop)
	c:RegisterEffect(ae1)
	--banish
	local ae3=Effect.CreateEffect(c)
	ae3:SetDescription(aux.Stringid(101010430,0))
	ae3:SetCategory(CATEGORY_REMOVE)
	ae3:SetType(EFFECT_TYPE_QUICK_O)
	ae3:SetCode(EVENT_FREE_CHAIN)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCountLimit(1,101010430)
	ae3:SetCondition(c101010430.con)
	ae3:SetCost(c101010430.nktg)
	ae3:SetTarget(c101010430.rmtg)
	ae3:SetOperation(c101010430.rmop)
	c:RegisterEffect(ae3)
	--return
	local ae5=Effect.CreateEffect(c)
	ae5:SetDescription(aux.Stringid(101010430,1))
	ae5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	ae5:SetType(EFFECT_TYPE_QUICK_O)
	ae5:SetCode(EVENT_FREE_CHAIN)
	ae5:SetRange(LOCATION_MZONE)
	ae5:SetCountLimit(1,101010430)
	ae5:SetCondition(c101010430.con)
	ae5:SetCost(c101010430.cost)
	ae5:SetTarget(c101010430.rttg)
	ae5:SetOperation(c101010430.rtop)
	c:RegisterEffect(ae5)
	if not c101010430.global_check then
		c101010430.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010430.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010430.spatial=true
--Spatial Formula filter(s)
c101010430.material1=function(mc) return mc:IsSetCard(0x167) end
-- c101010430.material2=function(mc) return true end -- Invert this block of code on Division Spatial Monsters (begin)
-- c101010430.addt_spatial=true c101010430.subt_spatial=true c101010430.mult_spatial=true --choose 1, depending on the Spatial Formula
c101010430.divs_spatial=true --Division Procedure /
c101010430.stat=function(mc) return mc:GetAttack() end
c101010430.indicator=function(mc) return mc:GetLevel() end -- Invert this block of code on Division Spatial Monsters (end)
function c101010430.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,450)
	Duel.CreateToken(1-tp,450)
end
function c101010430.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101010430.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x167) and c:IsAbleToRemoveAsCost()
end
function c101010430.nktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101010430.dfilter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010430.dfilter,tp,LOCATION_GRAVE,0,4,4,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010430.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c101010430.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFirstTarget()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and g:IsRelateToEffect(e) then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c101010430.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101010430.dfilter,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010430.dfilter,tp,LOCATION_GRAVE,0,5,8,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010430.cfilter(c)
	return not (c:IsSetCard(0x167) and c:IsType(TYPE_MONSTER))
end
function c101010430.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010430.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(c101010430.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	if e:GetLabel()==8 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c101010430.rtop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c101010430.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	if e:GetLabel()==8 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c101010430.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010430.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
