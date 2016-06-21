--FFD－プロミネンス
local id,ref=GIR()
function ref.start(c)
--damage conversion
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(function(e) return e:GetHandler():IsHasEffect(id) end)
	e1:SetValue(ref.rev)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(ref.rectg)
	e2:SetOperation(ref.recop)
	c:RegisterEffect(e2)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,ref.ffilter1,ref.ffilter2,true)
end
function ref.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) or (c:IsHasEffect(id) and not c:IsLocation(LOCATION_DECK))
end
function ref.ffilter2(c)
	return c:IsRace(RACE_WINDBEAST+RACE_PYRO) or (c:IsHasEffect(id) and not c:IsLocation(LOCATION_DECK))
end
function ref.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
	local bc=Duel.GetAttacker()
	if bc==e:GetHandler() then bc=Duel.GetAttackTarget() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,bc,1,0,0)
end
function ref.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local bc=Duel.GetAttacker()
	if bc==e:GetHandler() then bc=Duel.GetAttackTarget() end
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and bc~=nil then Duel.SendtoDeck(bc,nil,2,REASON_EFFECT) end
end
function ref.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_EFFECT)>0
end
