--ＳＳ－リーム・イクスパンス・ドラゴン
local id,ref=GIR()
function ref.start(c)
--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(ref.aclimit)
	e3:SetCondition(ref.actcon)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e2)
	--At the end of the Damage Step, if this card attacked: Draw 1 card, then, you can Special Summon 1 monster from your hand, and if you do, destroy up to 3 monsters your opponent controls.
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_DAMAGE_STEP_END)
	e0:SetCountLimit(1,id)
	e0:SetCondition(ref.con)
	e0:SetTarget(ref.tg)
	e0:SetOperation(ref.op)
	c:RegisterEffect(e0)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetOperatedGroup():Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:GetFirst()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil):Select(tp,1,3,nil)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function ref.aclimit(e,re,tp)
	return re:GetHandler()~=e:GetHandler() and not re:GetHandler():IsImmuneToEffect(e)
end
function ref.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
